Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab1BAHjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 02:39:05 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34069 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab1BAHjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 02:39:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=fYcnDCs/Ch1JJCv35j5wm8Z7dsPHSkImA0GalGbQ9G3CUI+AV4rI5/D4v7V8JaXaUB
         s7gHt5irWM255W4gNgtzmvyNsz9P0b45T7Vt6FBp+LOBWAuWKcdCmKDU9eGCuEeMbjV/
         HM1uGjhWOHFdXf+9B4Z5OOpD8O63FMOvd8Qxk=
Date: Tue, 1 Feb 2011 15:38:53 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, kosaki.motohiro@jp.fujitsu.com,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
Subject: Re: Query about kdump_msg hook into crash_kexec()
Message-ID: <20110201073853.GB21239@cr0.nay.redhat.com>
References: <20110131225939.GH11974@redhat.com>
 <20110201071933.GA21239@cr0.nay.redhat.com>
 <m1hbcous3o.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m1hbcous3o.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 11:33:15PM -0800, Eric W. Biederman wrote:
>Américo Wang <xiyou.wangcong@gmail.com> writes:
>
>> On Mon, Jan 31, 2011 at 05:59:39PM -0500, Vivek Goyal wrote:
>>>
>>>Anyway, if an image is loaded and we have setup to capture dump also
>>>why do we need to save kmsg with the help of an helper. I am assuming
>>>this is more of a debugging aid if we have no other way to capture the
>>>kernel log buffer. So if somebody has setup kdump to capture the
>>>vmcore, why to call another handler which tries to save part of the
>>>vmcore (kmsg) separately.
>>>
>>
>> Well, kmsg dumper is not only for panic/oops, it can also save kernel
>> messages when the system is reboot/halt.
>>
>> Yeah, it is true that vmcore contains log_buf, but I think the users
>> of ramoops/mtdoops are mainly those who don't have kdump configured
>> in their kernels, they are cheaper than kdump, but less powerful
>
>The issue is the inane call inside crash_kexec.
>
>It requires both a kexec kernel to be loaded and it requires you to be
>crashing.  Given that when I audited the kmsg_dump handlers they really
>weren't safe in a crash dump scenario we should just remove it.
>

Probably, I think we need to get rid of KMSG_DUMP_KEXEC.

