Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab2I0URh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 16:17:37 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35360 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab2I0URg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 16:17:36 -0400
MIME-Version: 1.0
In-Reply-To: <1348724705-23779-4-git-send-email-wency@cn.fujitsu.com>
References: <1348724705-23779-1-git-send-email-wency@cn.fujitsu.com> <1348724705-23779-4-git-send-email-wency@cn.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 27 Sep 2012 16:17:15 -0400
X-Google-Sender-Auth: tfMSEBFv6LDiWOzh9CKymObaQ_A
Message-ID: <CAHGf_=qhBSvOgStSgmcKZY8qMyj_Fp=3RLMD08YM8F9NzuY28Q@mail.gmail.com>
Subject: Re: [PATCH 3/4] memory-hotplug: clear hwpoisoned flag when onlining pages
To: wency@cn.fujitsu.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, minchan.kim@gmail.com, akpm@linux-foundation.org,
        isimatu.yasuaki@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 1:45 AM,  <wency@cn.fujitsu.com> wrote:
> From: Wen Congyang <wency@cn.fujitsu.com>
>
> hwpoisoned may set when we offline a page by the sysfs interface
> /sys/devices/system/memory/soft_offline_page or
> /sys/devices/system/memory/hard_offline_page. If we don't clear
> this flag when onlining pages, this page can't be freed, and will
> not in free list. So we can't offline these pages again. So we
> should clear this flag when onlining pages.

This seems wrong fix to me.  After offline, memory may or may not
change with new one. Thus we can't assume any memory status. Thus,
we should just forget hwpoison status at _offline_ event.
