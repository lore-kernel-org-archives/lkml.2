Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab2CMUpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 16:45:20 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55077 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2CMUpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 16:45:17 -0400
Message-ID: <4F5FB1DA.6070009@pobox.com>
Date: Tue, 13 Mar 2012 16:45:14 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: kernel-janitors@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        wharms@bfs.de, w.sang@pengutronix.de, agust@denx.de
Subject: Re: [PATCH v3] drivers/ata/pata_mpc52xx.c: clean up error handling
 code
References: <1331496729-12850-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1331496729-12850-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2012 04:12 PM, Julia Lawall wrote:
> From: Julia Lawall<Julia.Lawall@lip6.fr>
>
> This patch makes a number of changes with respect to the error-handling
> code:
>
> * Remove cleanup calls for the devm functions in both the error handling
>    code and the remove function.  This cleanup is done automatically.
>
> * The previous change simplifies the cleanup code at the end of the
>    function such that there is nothing to do on the failure of the call to
>    devm_ioremap.  So it is changed to just return directly.
>
> * There is no need for the ifs in the cleanup code at the end of the
>    function, because in each case the cleanup needed is statically
>    known.  Drop the ifs, add new err labels, and drop the initializations of
>    the tested variables to NULL.
>
> * Change the call to request_irq to a call to devm_request_irq, so that it
>    is cleaned up on exit.
>
> * Cause the return value of devm_request_irq to go into the returned
>    variable rv rather than the unused variable ret.  Drop ret.
>
> Signed-off-by: Julia Lawall<Julia.Lawall@lip6.fr>
>
> ---
> This subsumes the previous patch that only removed the calls to the devm
> cleanup functions.  It is not tested.  I am not sure about the correctness
> of the use of devm_request_irq, since there were no calls to free_irq
> before.  I also don't know if there was a reason for not returning the
> return value of request_irq previously.
>
>   drivers/ata/pata_mpc52xx.c |   44 +++++++++++++++-----------------------------
>   1 file changed, 15 insertions(+), 29 deletions(-)

applied



