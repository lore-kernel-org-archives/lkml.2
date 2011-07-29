Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab1G2PEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 11:04:42 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:37336 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750844Ab1G2PEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 11:04:40 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: BodVKmQVM1mswrpoPYiv6eygAnbWmGgwzD4Z64qJZo8SDq1
 .dU7zRQOvsGHH9JsWe2dCN4pQpx_J.CNYzC8lK2VKbj2vWlt3yIV0UKpDmr9
 AEoS1b1H26A2GDZxcYzNa4hf.AFDWiNtEfgEhPO3_FBgdXAQLzwwu_zZQnxC
 qrHWKVLCKB1o2fb0q7.xnf3ZJtiVBVRvduhrNC_UxZFzJcZis.6lCwIt0ewn
 a9KQ3sL7vrKzb1jPA8ndRraJxgRoAY_guZxtV1lWhFjWYWO5lJE2E2NHmwdJ
 s9DZd6rilXa5xO82vpD3t.WoGUyp2P5vu1yMR4Krlo..zCVmHNjAKSaj_ojM
 yxC7dwx2u_JW_fzIp5l_hgsqe
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 29 Jul 2011 10:04:36 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        rientjes@google.com, hughd@google.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [GIT PULL] Lockless SLUB slowpaths for v3.1-rc1
In-Reply-To: <alpine.DEB.2.00.1107290145080.3279@tiger>
Message-ID: <alpine.DEB.2.00.1107291002570.16178@router.home>
References: <alpine.DEB.2.00.1107290145080.3279@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jul 2011, Pekka Enberg wrote:

> We haven't come up with a solution to keep struct page size the same but I
> think it's a reasonable trade-off.

The change requires the page struct to be aligned to a double word
boundary. There is actually no variable added to the page struct. Its just
the alignment requirement that causes padding to be added after each page
struct.

