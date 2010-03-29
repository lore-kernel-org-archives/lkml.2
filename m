Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab0C2SM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:12:26 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34749 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab0C2SMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:12:25 -0400
Subject: Re: Regression in virtio_net causing kernel BUG when running under
 VirtualBox (bisected)
From: Shirley Ma <mashirle@us.ibm.com>
To: Thomas =?ISO-8859-1?Q?M=FCller?= <thomas@mathtm.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4BAE1707.2050803@mathtm.de>
References: <4BAE1707.2050803@mathtm.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 11:12:21 -0700
Message-ID: <1269886341.13277.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

Good catch! The problem was sg_init_table was missing for small buffer
size. When CONFIG_DEBUG_SG is off, you won't hit this, but your test has
DEBUG_SG on so SG_MAGIC check failed. You can turn DEBUG_SG off to avoid
this.

I thought you should hit the same problem before since I didn't remember
sg_init_table was used for small message size.

I will submit a patch for fix this issue soon.

Thanks
Shirley

