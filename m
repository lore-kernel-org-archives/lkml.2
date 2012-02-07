Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab2BGQ2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 11:28:01 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:37997 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754525Ab2BGQ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 11:27:59 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Cxam9G0VM1lOekinYTk0mqavnxxqTnijFS0w9eSk0H.vetM
 d7vzXrva8xSr7yPhMPdV9QW3QkjlLC8XC.JjcZOntuLKjcJstAfCOcf3UkQo
 Nez.kzpw1rUIV3vqoHk75O7S.1JbGDiC7NWrPiA5q6ALp4lQOgxUdKN0UfB3
 0J8zCtptjZpQlEM7jhFsReCIi9vawfm_q80DwRIKeEZvPhLD69iTNc0KDrRm
 4U9yv.AV5_5V8po94YP4TCMKbUFjymD5YVTAN5BH9VHJiAxU5wksZgOaFLiq
 IuynYF1A1HxzEB2w43OZ1hqN9VJCErwFZQ_B2dA3E3oUQXA8jeOV5Wcx_TA0
 nyh1N.IlMG4Q9gemOMzZF0C7BkAxvADuhfN_7OP_uj7qN_dOlnTVwvZkUIdR
 1
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 7 Feb 2012 10:27:56 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 02/15] mm: sl[au]b: Add knowledge of PFMEMALLOC reserve
 pages
In-Reply-To: <1328568978-17553-3-git-send-email-mgorman@suse.de>
Message-ID: <alpine.DEB.2.00.1202071025050.30652@router.home>
References: <1328568978-17553-1-git-send-email-mgorman@suse.de> <1328568978-17553-3-git-send-email-mgorman@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Feb 2012, Mel Gorman wrote:

> Pages allocated from the reserve are returned with page->pfmemalloc
> set and it is up to the caller to determine how the page should be
> protected.  SLAB restricts access to any page with page->pfmemalloc set

pfmemalloc sounds like a page flag. If you would use one then the
preservation of the flag by copying it elsewhere may not be necessary and
the patches would be less invasive. Also you would not need to extend
and modify many of the structures.

