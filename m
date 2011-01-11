Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab1AKNGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 08:06:47 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44404 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab1AKNGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 08:06:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=uDCPH7Lv9EFxi5GGT0qkw75A41O7y9+hIt6DR6PCvEf5snJ71BewyHZ6icwYPd6b9z
         k2q+hqJWwcOwhMCaryIpwQOtDbbXqC+ZFc3+ZxPw4wwiimDzyTHuVbO3Ij+Qx2iFK62y
         L8/vot8cXKGLGoa1zh1/rlzXlZ2Z5GqKMnDb0=
MIME-Version: 1.0
In-Reply-To: <20110111010800.GE4879@mail.oracle.com>
References: <AANLkTimBrR1LkVHOxZA=UUmKsnxfsFLr9z_AhXUHQ_7N@mail.gmail.com>
	<20110111010800.GE4879@mail.oracle.com>
Date: Wed, 12 Jan 2011 00:06:42 +1100
Message-ID: <AANLkTimrqb5e9QKT7UFLXtQHap689kSoEZRmLvax5Xm-@mail.gmail.com>
Subject: Re: Important for fs devs: rcu-walk merged upstream
From: Nick Piggin <npiggin@gmail.com>
To: Nick Piggin <npiggin@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 11, 2011, Joel Becker <jlbec@evilplan.org> wrote:
> On Sat, Jan 08, 2011 at 01:54:47PM +1100, Nick Piggin wrote:
>> The rcu-walk stuff can be more tricky for your filesystem
>> to take advantage of.
>>
>> If you supply a .d_revalidate, .permission, or .check_acl,
>> then path walking is going to be slow and unscalable for
>> you.
>
>         Do you mean "as slow and unscalable as it has always been" or
> "even slower now"?  A quick look suggests the former, but I wanted to be
> sure.

Yeah it should be about the same. Bit more complex code so it might be
a bit slower. A few code and branch and cache improvements so it might
be a bit faster. Refcounts on the same dentry become a bit less
scalable for using lock instead of atomic. On the other hand dropping
the ref on leaf denty doesn't require global lock.

It should not be urgent for 2.6.38.
