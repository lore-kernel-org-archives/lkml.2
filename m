Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab2HCPiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 11:38:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45947 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab2HCPh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 11:37:59 -0400
Message-ID: <501BF054.5050803@wwwdotorg.org>
Date: Fri, 03 Aug 2012 09:37:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Philip Avinash <avinashphilip@ti.com>
Subject: Re: [PATCH] pwm: Remove a redundant error message when devm_request_and_ioremap
 fails
References: <1344001434.25906.5.camel@phoenix>
In-Reply-To: <1344001434.25906.5.camel@phoenix>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 07:43 AM, Axel Lin wrote:
> The implementation in devm_request_and_ioremap() already shows error message,
> so no need to show dev_err again if devm_request_and_ioremap() fails.

I don't have any issue with this patch, but a general comment:

It sure would be nice if there was some way to easily tell which
functions did already print an error message. In some drivers I've
written, I've made sure that every failure path prints an error message
so it's easy to track down failures. However, if some functions already
do this and some don't, only some call sites in the driver will have
error prints, so it'll look inconsistent, as if some error messages were
forgotten:-(
