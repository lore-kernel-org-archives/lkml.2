Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab0CSKZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 06:25:52 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:29631 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab0CSKZv convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Fri, 19 Mar 2010 06:25:51 -0400
Message-Id: <4BA35F3E0200007800035DCC@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 19 Mar 2010 10:25:50 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, <arjan@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: latent problem in free_init_pages()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The calls to set_memory_rw() and set_memory_np() that both of you
added for 2.6.25 imply that both "begin" and "end" are page aligned.
This isn't the case, however, for the initrd and SMP locks. While at
present this doesn't appear to do any harm, it partly subverts the
debugging effect of the latter change and would result in a real issue
if the .smp_locks section was moved into the read-only portion of the
kernel image (where it really belongs imo).

Jan

