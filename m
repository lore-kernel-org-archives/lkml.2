Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab2DXQI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:08:29 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:20345 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755787Ab2DXQI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:08:28 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: vTFuifcVM1lcAkGse4ANgMO0jWb.MBNNzfaGQv8uHMvpClc
 aL7KbP3bTt2SCxH6mSOG4NXTAxO2dUzSSm22j88zIXOACgri0pClUvbnRu.p
 KCKryf_.hrv_C9bpaDfRY2xca9KuNUwLRxiCH9OruFtlZxhur1wxqHD3crqM
 V1R.BQTSx.et2gC_rP3jA7s7LYGgCe_3KE3mZMqADLTFpWz2pNEXz0ACHpir
 UfU7yicRbGch1DQ9MGyjnRbiW0KIDpxf4ImvqpAN3AVVxKiLnPWqny4XjWdp
 GtYZAkc3EG.UVGdCOsv9ONkBJeqMB4XXNsA15Ackexc52YTyI93aq_55UyYr
 EAvMa8HH5BLzgOcU7iijyk5L3oiyNDtrAf3B88V5v_9XqaZ80Yo4yqFynd8M
 5
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 24 Apr 2012 11:08:25 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Larry Woodman <lwoodman@redhat.com>
cc: linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Motohiro Kosaki <mkosaki@redhat.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm V2] do_migrate_pages() calls migrate_to_node() even
 if task is already on a correct node
In-Reply-To: <4F96CDE1.5000909@redhat.com>
Message-ID: <alpine.DEB.2.00.1204241106240.26005@router.home>
References: <4F96CDE1.5000909@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2012, Larry Woodman wrote:

> While moving tasks between cpusets we noticed some strange behavior.
> Specifically if the nodes of the destination
> cpuset are a subset of the nodes of the source cpuset do_migrate_pages() will
> move pages that are already on a node
> in the destination cpuset.  The reason for this is do_migrate_pages() does not
> check whether each node in the source
> nodemask is in the destination nodemask before calling migrate_to_node().  If
> we simply do this check and skip them
> when the source is in the destination moving we wont move nodes that dont need
> to be moved.

Acked-by: Christoph Lameter <cl@linux.com>
