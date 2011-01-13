Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab1AMA6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 19:58:36 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56168 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab1AMA6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 19:58:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dPXXX+R1SPGv4XqYPvDtdp7kCuwhHzv7pMctV2pm1dndus65SBt7DcKvFKzUGNTq9N
         wyJu0na6N0brmFpiSyApySyjrnTkrNM2J/LJd2mRn6H5FT3tv+9TY+hjkv/8woUUOJ7l
         qfKBnqBCNt1WAZHL2ZqUpC052ba7QA5QkVBK4=
MIME-Version: 1.0
In-Reply-To: <1294808464.2821.15.camel@perseus>
References: <20110107075831.GA14915@amd>
	<1294763679.2435.72.camel@doink>
	<AANLkTin67OXYYKk6y+_MKfXEXBz-F_+qAH0cpiJ24yEQ@mail.gmail.com>
	<1294768668.2435.177.camel@doink>
	<1294804776.2821.4.camel@perseus>
	<87aaj6u3oi.fsf@linux.vnet.ibm.com>
	<1294808464.2821.15.camel@perseus>
Date: Thu, 13 Jan 2011 11:58:32 +1100
Message-ID: <AANLkTikNa8dqkwA617QG6hkMRrVLXNWO+1jBRhoaQdio@mail.gmail.com>
Subject: Re: [announce] vfs-scale git tree update
From: Nick Piggin <npiggin@gmail.com>
To: Ian Kent <raven@themaw.net>
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>, aelder@sgi.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 4:01 PM, Ian Kent <raven@themaw.net> wrote:
> On Wed, 2011-01-12 at 10:19 +0530, Aneesh Kumar K. V wrote:
>> for 9p I did the other way round. lookup now set the dentry op for both
>> negative and positive dentries and rest of the place we dropped
>> d_set_d_op (b8b80cf37c7f0e32729262f805bc0fa81c3e9d12 have the details)
>
> Sadly I can't do that.
>
> For now I need to avoid calls to ->d_revalidate() as much as possible to
> reduce a potential deadlock and have access to the flags of the negative
> dentry (during create) for the purpose of blocking concurrent walks.

What prevents your d_revalidate from just checking for negative dentry?
