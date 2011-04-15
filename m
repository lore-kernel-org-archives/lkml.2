Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab1DOKfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 06:35:20 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:44318 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab1DOKfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 06:35:17 -0400
Message-ID: <4DA81F42.3070208@csr.com>
Date: Fri, 15 Apr 2011 11:34:42 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Per Forlin <per.forlin@linaro.org>
CC: <linux-mmc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linaro-dev@lists.linaro.org>,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH v2 01/12] mmc: add none blocking mmc request function
References: <1302116833-24540-1-git-send-email-per.forlin@linaro.org> <1302116833-24540-2-git-send-email-per.forlin@linaro.org>
In-Reply-To: <1302116833-24540-2-git-send-email-per.forlin@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.101.11.143]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/11 20:07, Per Forlin wrote:
> Previously there has only been one function mmc_wait_for_req
> to start and wait for a request. This patch adds
>  * mmc_start_req - starts a request wihtout waiting
>  * mmc_wait_for_req_done - waits until request is done
>  * mmc_pre_req - asks the host driver to prepare for the next job
>  * mmc_post_req - asks the host driver to clean up after a completed job

If MMC core had a queue of requests internally you wouldn't need to
provide mmc_pre_req() and mmc_post_req() functions outside of the core.
 i.e., the mmc block driver would just need to queue up two mmc requests
and the core would take care of calling pre_req and post_req at the
correct time.

Using a MMC request queue has other benefits -- it allows multiple users
without having to claim/release the host.  This would be useful for
(especially multi-function) SDIO.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
