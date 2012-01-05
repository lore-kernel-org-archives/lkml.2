Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab2AEJfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 04:35:37 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46093 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab2AEJff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 04:35:35 -0500
MIME-Version: 1.0
In-Reply-To: <4EFC79AD.3090104@redhat.com>
References: <1324091975-20930-1-git-send-email-kernelfans@gmail.com>
	<1324975139-8836-1-git-send-email-kernelfans@gmail.com>
	<4EF9AA59.7050003@oss.ntt.co.jp>
	<CAFgQCTu+qO=_Pc3Nps5N+esB0a9xYu83nRUT4Q6JepM6pAZYAA@mail.gmail.com>
	<4EFAE705.6070202@redhat.com>
	<CAFgQCTtFFOYY09Edg_ibNTRYfxHh1HRjqgpRyBy7jUZYJgEJxA@mail.gmail.com>
	<4EFC79AD.3090104@redhat.com>
Date: Thu, 5 Jan 2012 17:35:34 +0800
Message-ID: <CAFgQCTung6V4QorrWXhJJbg1B2mETMtz0e8Hch_4zgxU9CK_4w@mail.gmail.com>
Subject: Re: [PATCH v6] kvm: make vcpu life cycle separated from kvm instance
From: Liu ping fan <kernelfans@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        gleb@redhat.com, mtosatti@redhat.com, xiaoguangrong.eric@gmail.com,
        jan.kiszka@web.de, Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 10:31 PM, Avi Kivity <avi@redhat.com> wrote:
> On 12/29/2011 04:03 PM, Liu ping fan wrote:
>> > Why do we want an independent grace period, is hotunplugging a vcpu that
>> > much different from hotunplugging memory?
>> >
>> I thought that if less readers on the same srcu lock, then
>> synchronize_srcu_expedited() may success to return more quickly.
>
> It would be good to measure it, otherwise it's premature optimization.
>
Yes, after using kprobetrace to measure it, I found it was  premature
optimization. So I will resort to the kvm->srcu, instead of creating a
new one in next version.

Thanks and regards
ping fan
> --
> error compiling committee.c: too many arguments to function
>
