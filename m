Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966766Ab2EOUg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 16:36:57 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:28255 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S966671Ab2EOUgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 16:36:55 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: p4D55FcVM1nGIpo75GjydpN5Qvw1ZSyLAzgYKSRyQNCN8oi
 hwsyFyLNUwENRkSM_bNhxVC2TtJOXbnQ3_1YosviHm14mmgsIJNXL1DYzYn9
 XZhfn3yCUTq0pc0fY.6yDegndT0Tb6TcLumQU5kUhWZJDpmh0yVlg9rX7tQd
 jLHaNEqXVTfNCbk809pjLaR2F995Bc9hlEr0.vCXRzmcusvMSz45IiwBhuYu
 B5cAAZk5x9M0zB5bqyIl9kILKoMJJMJQito.zHpyUEo_ep36b1fNU1U4d6Cu
 k2M_kvrPhcRVpkasjeUO5bB87fayFr76aIx5bglkKI0EWHbqIx7wz_.8Ghn.
 OuwU4QtxAitlH1bVc1IWTRoKz36Ngpzcw7b2l1zO8ytv613ES8L5IZRSLNw8
 1Cu.T.AiqlWlj6ZhXyFAachmD8A3xUCpDN1dq
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 15 May 2012 15:36:52 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Joonsoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] slub: fix a memory leak in get_partial_node()
In-Reply-To: <1337108498-4104-1-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1205151527150.11923@router.home>
References: <1337108498-4104-1-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012, Joonsoo Kim wrote:

> In the case which is below,
>
> 1. acquire slab for cpu partial list
> 2. free object to it by remote cpu
> 3. page->freelist = t
>
> then memory leak is occurred.

Hmmm... Ok so we cannot assign page->freelist in get_partial_node() for
the cpu partial slabs. It must be done in the cmpxchg transition.

Acked-by: Christoph Lameter <cl@linux.com>
