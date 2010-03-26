Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab0CZLsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 07:48:01 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:44119 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab0CZLr7 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:2:1>);
	Fri, 26 Mar 2010 07:47:59 -0400
Message-Id: <4BACAD00020000780003726B@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 26 Mar 2010 11:48:00 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <yinghai@kernel.org>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: free_bootmem() == free_early() with CONFIG_NO_BOOTMEM
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why is free_bootmem() not calling free_early_partial() instead? I don't
think the (legacy?) bootmem allocator had a restriction on not allowing
partial blocks to be returned, and it certainly didn't fail on fragments of
blocks previously reserved with reserve_early() being freed.

Seems like a regression to me, but I'd like to understand first if there
is any deeper reason behind the chosen solution.

Thanks, Jan

