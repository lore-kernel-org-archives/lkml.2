Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab2G0Uyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 16:54:38 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:29664 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751314Ab2G0Uyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 16:54:37 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: D75rDgIVM1lx6F76Elw_Rgd9QyCGHe096iI5WiZxU_IDQCn
 GwvPRL3iWOdg9sv4Pr.JxZc1tVt3M23AV0yJKDagqdHCb.Q3m5BjxLxZyGIl
 d8eTLHC4Qwg5e98gaWY4D7QK_Xs9twN1Qv1KC08V557YbUuOZ1e6DbxHi1n2
 R1o7iH35nmjYFMjyrDZVHkc30rWRI1Itv2Zcq9uyCFrkJUPsQOxqnkKYryRw
 V1SDrrSyfFhWIvmivU.jpYi1bkrXPuEENF_H0rV36fOC6n1kO29yDxuRLT_1
 pRloRwdy2Hugm6BXnMt8S7yP8mW9n7oTNCtqC1nU0bbtYR7_XqjsX4o4XO6Q
 Ga.n_VPMcUWwOQPYo0e5gk_UnWC9ei0_1eK4NC2qQjd0nT.SGD8em63k9fP6
 jhaoZRdCXZrMWjhVfeCLgKZ6tiRTNSa70DXsqPpnviuaBaguiN6I-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 27 Jul 2012 15:54:34 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Joonsoo Kim <js1304@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Brice Goglin <brice@myri.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [RESEND PATCH 4/4 v3] mm: fix possible incorrect return value
 of move_pages() syscall
In-Reply-To: <1343411703-2720-4-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1207271550190.25434@router.home>
References: <Yes> <1343411703-2720-1-git-send-email-js1304@gmail.com> <1343411703-2720-4-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jul 2012, Joonsoo Kim wrote:

> move_pages() syscall may return success in case that
> do_move_page_to_node_array return positive value which means migration failed.

Nope. It only means that the migration for some pages has failed. This may
still be considered successful for the app if it moves 10000 pages and one
failed.

This patch would break the move_pages() syscall because an error code
return from do_move_pages_to_node_array() will cause the status byte for
each page move to not be updated anymore. Application will not be able to
tell anymore which pages were successfully moved and which are not.
