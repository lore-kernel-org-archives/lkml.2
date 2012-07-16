Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab2GPRXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 13:23:21 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:29467 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753272Ab2GPRXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 13:23:19 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: vkNleDEVM1klt.6NdOoAebc5aOExggmKBeO5LVEShAyxWnL
 9MA4HiIh6rEhr6U2pXgzY2ofNPtDWp671gUc4BDKV4kXB9AbBco2Gy0wArH1
 QKdL6pLxzyTX09RrAvp08ucZ0ie9AFRgh3xpKmPm7BQlyVwKesSH6mDS9D3C
 p8oAtmpkxTTjKMRbOXTXudv8g9p0uYdZv50cM3GwjyzXx7qwdqMZOVhSGRnZ
 .3ljqg5hvetDG2z1sQ3.8_dVjewVgKE2PEQKHD1zr4iYupT2evH76YXFlzdI
 6T0nMZoDJOE8x8JkJu3QDFbokJtc21B3LytjIYHzdvDoc4LajUQxNQmnsAgx
 0rgvZ5vvfcMT2VSBbZNEme4OeAijwPc9_CfqJZ.JY17l.WA6raXG7TQqzVj0
 __XI0xUL.60_xi.rOT_LPdGRlAGnlglxDw3WZ
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 16 Jul 2012 12:23:16 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Joonsoo Kim <js1304@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: correct return value of migrate_pages()
In-Reply-To: <1342455272-32703-1-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1207161220440.32319@router.home>
References: <Yes> <1342455272-32703-1-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2012, Joonsoo Kim wrote:

> migrate_pages() should return number of pages not migrated or error code.
> When unmap_and_move return -EAGAIN, outer loop is re-execution without
> initialising nr_failed. This makes nr_failed over-counted.

The itention of the nr_failed was only to give an indication as to how
many attempts where made. The failed pages where on a separate queue that
seems to have vanished.

> So this patch correct it by initialising nr_failed in outer loop.

Well yea it makes sense since retry is initialized there as well.

Acked-by: Christoph Lameter <cl@linux.com>
