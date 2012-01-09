Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab2AILny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 06:43:54 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.27]:43889 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab2AILnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 06:43:53 -0500
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jan 2012 06:43:53 EST
Date: Mon, 9 Jan 2012 12:37:49 +0100
From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
To: linux-kernel@vger.kernel.org
Subject: Linux 3.2.0 Oops/Recursive fault on shutdown
Message-ID: <20120109113749.GA4147@EIS>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Df-Sender: bXNtdHBAbWV0YW1vcnBoZXIuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after upgrading the kernel to 3.2 the system oopsed on shutdown. 
Unfortunately there was nothing in the logs so all I have is 
a photo of the screen. System is an Intel Desktop (E8400), 
using cryptsetup / mdadm / LVM.

I posted it along with kernel config / system.map / lspci here:

http://www.metamorpher.de/kp32/

Function names mentioned in the trace:
(full info please see the screenshot)

? wq_worker_sleeping
? __schedule
? do_exit
? oops_end
? do_invalid_op
? md_write_start
? ata_scsi_simulate
? cpumask_next_and
? find_busiest_group
? invalid_op
? md_write_start
? blkcipher_walk_done
? make_request
? crypto_aes_decrypt_x86
? encrypt
? md_make_request
? crypt_convert
? generic_make_request
? kcryptd_crypt
? kcryptd_async_done
? process_one_work
? worker_thread
? manage_workers.clone.26
? manage_workers.clone.26
? kthread
? kernel_thread_helper
? kthread_worker_fn
? gs_change
? kthread_data

Haven't been able to reproduce the issue so far, but maybe the 
screenshot tells someone something that needs fixing.

Regards
Andreas Klauer
