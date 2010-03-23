Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0CWNbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 09:31:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39610 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab0CWNbQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 09:31:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=qF1wTmyBsxgWTyZKWUxlVyE1T+RolXx/PQ6LeKFmegrkgNSQaBL7dVnS7gWAA6Puj
	GydgMuBHmmjbTQwoSN3Hw==
MIME-Version: 1.0
In-Reply-To: <4BA8ADB8.1030802@ladisch.de>
References: <20100323090206.33932wop73sdefm6@unsolicited.net>
	 <4BA8ADB8.1030802@ladisch.de>
Date: Tue, 23 Mar 2010 14:31:04 +0100
Message-ID: <bd4cb8901003230631q22cdac6dg8011489b94c6d5e0@mail.gmail.com>
Subject: Re: 2.6.34-rc2 - crash on shutdown
From: Stephane Eranian <eranian@google.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: David R <david@unsolicited.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 1:02 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
> David R wrote:
>> I recently upgraded my kernel to the .34 rc, and I'm getting the
>> following crash on shutdown (see attached console image)
>
> Mee too, also in amd_pmu_cpu_offline().
>
> The only pointer access in this function is cpuhw->amd_nb, but
> I don't see any obvious bugs.
>
>
I reported a problem with the AMD initialization just last week.
There is an issue with amd_pmu_cpu_online() which gets called
too early, and thus fails. That leaves some bogus state and causes
a crash in amd_pmu_cpu_offline().

I proposed a fix which was rejected. The alternative involves moving
some the of CPU initialization code (on AMD) to an earlier position,i.e.,
which would be executed before the CPU_STARTED notifier. Nobody
has proposed anything else so far.


> Regards,
> Clemens
>



-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
