Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab2JSHBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 03:01:35 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57228 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab2JSHBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 03:01:33 -0400
MIME-Version: 1.0
In-Reply-To: <1350629202-9664-4-git-send-email-wency@cn.fujitsu.com>
References: <1350629202-9664-1-git-send-email-wency@cn.fujitsu.com> <1350629202-9664-4-git-send-email-wency@cn.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 19 Oct 2012 03:01:12 -0400
X-Google-Sender-Auth: Dh3ai62Ux4P66BM_7wpbunV1_vI
Message-ID: <CAHGf_=oAH+Ky9JbrMrEsd53=a1NBq1+jtr1HkBwnGm4qBZCRAw@mail.gmail.com>
Subject: Re: [PATCH v3 3/9] memory-hotplug: flush the work for the node when
 the node is offlined
To: wency@cn.fujitsu.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, minchan.kim@gmail.com, akpm@linux-foundation.org,
        isimatu.yasuaki@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 2:46 AM,  <wency@cn.fujitsu.com> wrote:
> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>
> If the node is onlined after it is offlined, we will clear the memory
> to store the node's information. This structure contains struct work,
> so we should flush work before the work's information is cleared.

This explanation is incorrect. Even if you don't call memset(), you should
call flush_work() at offline event. Because of, after offlinining, we
shouldn't touch any node data. Alive workqueue violate this principle.

And, hmmm... Wait. Usually workqueue shutdowning has two phase. 1)
inhibit enqueue new work 2) flush work. Otherwise other cpus may
enqueue new work after flush_work(). Where is (1)?
