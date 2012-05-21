Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab2EUNiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 09:38:52 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18004 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab2EUNiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 09:38:51 -0400
Date: Mon, 21 May 2012 16:38:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: re: mm/mpol: Make MPOL_LOCAL a real policy
Message-ID: <20120521133838.GA12116@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter Zijlstra,

The patch 03ed7b538ca0: "mm/mpol: Make MPOL_LOCAL a real policy" from 
Mar 19, 2012, leads to the following warning:
mm/mempolicy.c:2591 mpol_parse_str()
	 error: buffer overflow 'policy_modes' 5 <= 5

mm/mempolicy.c
  2590          for (mode = 0; mode < MPOL_MAX; mode++) {
  2591                  if (!strcmp(str, policy_modes[mode])) {
  2592                          break;
  2593                  }
  2594          }

The problem is that MPOL_NOOP is not defined in policy_modes[] so we
search past the end of the array.

regards,
dan carpenter

