Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab1FUNdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 09:33:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756560Ab1FUNdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 09:33:33 -0400
Date: Tue, 21 Jun 2011 15:32:36 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] mm: introduce no_ksm to disable totally KSM
Message-ID: <20110621133236.GP20843@redhat.com>
References: <1308643849-3325-1-git-send-email-amwang@redhat.com>
 <1308643849-3325-4-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308643849-3325-4-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 04:10:45PM +0800, Amerigo Wang wrote:
> Introduce a new kernel parameter "no_ksm" to totally disable KSM.

Here as well this is the wrong approach. If you want to save memory,
you should make ksmd quit when run=0 and start only when setting
ksm/run=1. And move the daemon hashes and slabs initializations to the
ksmd daemon start. Not registering in sysfs and crippling down the
feature despite you loaded the proper .text into memory isn't good.
