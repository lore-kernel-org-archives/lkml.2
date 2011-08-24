Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab1HXRC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 13:02:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52645 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab1HXRCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:02:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
Date: Wed, 24 Aug 2011 19:02:46 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Colin Walters <walters@verbum.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org> <CADkLE3Ux1gVBR0f1VUNP4JDsnDQPUQ8rJrXqPV7-2kdLW0_CCw@mail.gmail.com> <CACVxJT93c+tYryWGPdw6LM9X+3b_QT78B0D9JwksksvN0akBkQ@mail.gmail.com>
In-Reply-To: <CACVxJT93c+tYryWGPdw6LM9X+3b_QT78B0D9JwksksvN0akBkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108241902.46537.arnd@arndb.de>
X-Provags-ID: V02:K0:DoqgnU7PlFBkLPrL/Z79IfYwbAho/oRVED4JDl9FZeC
 Yp9HIGZO4dJ9JebgjOpbpGKWTTVwoOyRkPTthooCe89VI63SL/
 3TfWj/BPeuOTrcwdACP36Qe4uRt3+VxEBZnBlWjpfird6CtRqy
 tv6uxTc0hpJvcMMjrSMiNWOwKr2SjhzU9RIwrf8q3NQawf09v8
 F0cVwRlsVOXEx+RZD1H/YSOK8Di9W+EL6YPm8xfFrIlR9EUEAP
 JscMdd5VcjsucrV36lnNW0aSUqq/Wli6KAu4Zb81XvNeni0S/5
 0OISPt6WCruB/aKn74vWSQEf6Y2l1poy2BOF3Sy/6VMXqCb1rw
 QL5BsqPXkZYz3hsVdH64=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 August 2011, Alexey Dobriyan wrote:
> Was this fixed? Yes.
> Will this break one more time? Of course!
> 
>          case "${kernel}" in
> -             2.6.*)
> +             2.6.*|3.*)
>                     AC_MSG_RESULT([2.6 family (${kernel})])

What you need is an exaustive list of past versions plus
a catch-all for future versions:

	case "${kernel}" in
		1.*|2.0.*|2.1.*|2.2.*|2.3.*)
			echo "too old"
			;;
		2.4.*)
			echo "Linux-2.4 style"
			;;
		2.5.*)
			echo "unstable and not supported"
			;;
		*)
			echo "2.6 or newer"
			;;
	esac

We don't break ABIs as a rule, so you should always assume
that a newer version will keep working.

	Arnd
