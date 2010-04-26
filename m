Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab0DZMeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 08:34:25 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43450 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab0DZMeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 08:34:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=cjec88R4jjLzP4Od1EPMb1s2SZxNv8EVR/zsNylN1Yo3xzR7yFA5sYeGEKotw5LDFp
         p9CSnafTDQTaih+GqW8nShM8fmrKWtXIY0YV27CUPldqSLLcF/SuDRJvYDQRVgA1enut
         eQNwgu7WSAL1Y9BefEsr5YcrZjolgim/l7I38=
Message-ID: <4BD58848.8090205@gmail.com>
Date: Mon, 26 Apr 2010 14:34:16 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: deadline ALWAYS default for dasd devices(s390) ?
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

why is it FORCED ? bypassing a GLOBAL setting and also the kernel command line !!!

drivers/s390/block/dasd.c

/*
 * Allocate and initialize request queue and default I/O scheduler.
 */
static int dasd_alloc_queue(struct dasd_block *block)
{
	int rc;

	block->request_queue = blk_init_queue(do_dasd_request,
					       &block->request_queue_lock);
	if (block->request_queue == NULL)
		return -ENOMEM;

	block->request_queue->queuedata = block;

	elevator_exit(block->request_queue->elevator);
	block->request_queue->elevator = NULL;
	rc = elevator_init(block->request_queue, "deadline");
	if (rc) {
		blk_cleanup_queue(block->request_queue);
		return rc;
	}
	return 0;
}


-thanks-

-- 
«Allá muevan feroz guerra, ciegos reyes por un palmo más de tierra;
que yo aquí tengo por mío cuanto abarca el mar bravío, a quien nadie
impuso leyes. Y no hay playa, sea cualquiera, ni bandera de esplendor,
que no sienta mi derecho y dé pecho a mi valor.»
