Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552Ab2EASGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:06:01 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36561 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758492Ab2EASGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:06:00 -0400
Message-ID: <4FA02603.80807@openvz.org>
Date: Tue, 01 May 2012 22:05:55 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH RFC 3/3] proc/smaps: show amount of hwpoison pages
References: <20120430112903.14137.81692.stgit@zurg> <20120430112910.14137.28935.stgit@zurg> <CAHGf_=rWDMMv2dKz3paV2MnjsCNWBa2BaUTi+RnDo8DZ4zEr=g@mail.gmail.com>
In-Reply-To: <CAHGf_=rWDMMv2dKz3paV2MnjsCNWBa2BaUTi+RnDo8DZ4zEr=g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> On Mon, Apr 30, 2012 at 7:29 AM, Konstantin Khlebnikov
> <khlebnikov@openvz.org>  wrote:
>> This patch adds line "HWPoinson:<size>  kB" into /proc/pid/smaps if
>> CONFIG_MEMORY_FAILURE=y and some HWPoison pages were found.
>> This may be useful for searching applications which use a broken memory.
>
> I dislike "maybe useful" claim. If we don't know exact motivation of a feature,
> we can't maintain them especially when a bugfix can't avoid ABI change.
>
> Please write down exact use case.

I don't know how to exactly use this hw-poison stuff, but smaps suppose to
export state of ptes in vma. It seems to rational to show also hw-poisoned ptes,
since kernel has this feature and pte can be in hw-poisoned state.

and now everyone can easily find them:
# sudo grep HWPoison /proc/*/smaps
