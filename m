Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630Ab2DQSYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:24:40 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50213 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2DQSYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:24:39 -0400
Message-ID: <4F8DB564.2060205@gmail.com>
Date: Tue, 17 Apr 2012 14:24:36 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: PINTU KUMAR <pintu_agarwal@yahoo.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "pintu.k@samsung.com" <pintu.k@samsung.com>, kosaki.motohiro@gmail.com
Subject: Re: [NEW]: Introducing shrink_all_memory from user space
References: <1334483226.20721.YahooMailNeo@web162003.mail.bf1.yahoo.com>
In-Reply-To: <1334483226.20721.YahooMailNeo@web162003.mail.bf1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/15/12 5:47 AM), PINTU KUMAR wrote:
> Dear All,
>
> This is regarding a small proposal for shrink_all_memory( ) function which is found in mm/vmscan.c.
> For those who are not aware, this function helps in reclaiming specified amount of physical memory and returns number of freed pages.
>
> Currently this function is under CONFIG_HIBERNATION flag, so cannot be used by others without enabling hibernation.
> Moreover this function is not exported to the outside world, so no driver can use it directly without including EXPORT_SYMBOL(shrink_all_memory) and recompiling the kernel.
> The purpose of using it under hibernation(kernel/power/snapshot.c) is to regain enough physical pages to create hibernation image.

This is intended. current shrink_all_memory() is not designed for generic purpose. It doesn't care numa affinity etc..
In future, we may remove this function completely because actually hibernation don't depend on it. it only help to
improvement hibernation speed-up a bit.
