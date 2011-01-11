Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab1AKM51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:57:27 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36004 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab1AKM5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:57:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kxoXIuTNuESuu7PojRM9YapYAOGcNiTGV4ApDm7QhymcqsqA12HHe5podpO8XBss1I
         0Cvy31ij7VMEzTZWxMrRpmmnsy0NisKZc0pznln804BxrvqHTHedT7xDmnqXPjoJwxE2
         PPOm/FRCudZhTHD0IkzMTY52PZKrf3Mp/x4S0=
MIME-Version: 1.0
In-Reply-To: <22537.1294670327@jrobl>
References: <AANLkTimBrR1LkVHOxZA=UUmKsnxfsFLr9z_AhXUHQ_7N@mail.gmail.com>
	<22537.1294670327@jrobl>
Date: Tue, 11 Jan 2011 23:57:22 +1100
Message-ID: <AANLkTi=Mfj1WBO2567ogjU=8xwfGO9OVH5V+wmURa5qo@mail.gmail.com>
Subject: Re: Important for fs devs: rcu-walk merged upstream
From: Nick Piggin <npiggin@gmail.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 11, 2011, J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
>
> Nick Piggin:
>> This is a big and complex change by any measure, so
>> please don't be afraid to ask for help or clarification. I'd
>> also really like to be able to update documentation
>> based on questions from fs maintainers (in and out of
>> tree) who are trying to follow it and bring their code up to
>> speed.
>
> Question about what d_lock protects.
> Can we skip d_lock when we access d_inode and d_name during its parent
> i_mutex is held?

That is a good observation. I think we are ok here because parent
mutex should stabilize children names and linkages.

But the documentation for a lot of locking is not complete. It would
be nice to improve.


> Should these BUG_ON be placed after d_lock?
>
> void dentry_update_name_case(struct dentry *dentry, struct qstr *name)
> {
>         BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
>         BUG_ON(dentry->d_name.len != name->len); /* d_lookup gives this */
>
>         spin_lock(&dentry->d_lock);
>         :::
>
>
> J. R. Okajima
>
