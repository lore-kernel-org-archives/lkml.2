Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab0LHBK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:10:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754061Ab0LHBKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:10:54 -0500
Date: Tue, 7 Dec 2010 17:10:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: linux-kernel@vger.kernel.org, pv-drivers@vmware.com
Subject: Re: [PATCH] VMware balloon: stop locking pages when hypervisor
 tells us enough
Message-Id: <20101207171023.d28e20ee.akpm@linux-foundation.org>
In-Reply-To: <20101203165226.GA16146@dtor-ws.eng.vmware.com>
References: <20101203165226.GA16146@dtor-ws.eng.vmware.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Dec 2010 08:52:26 -0800
Dmitry Torokhov <dtor@vmware.com> wrote:

> When hypervisor decides to decrease target balloon size while the
> balloon driver tries to lock pages hypervisor may respond with
> VMW_BALLOON_PPN_NOTNEEDED. Use this data and immediately stop reserving
> pages and wait for the next update cycle to fetch new target instead
> of continuing trying to lock pages until size of refused list grows
> above VMW_BALLOON_MAX_REFUSED (16) pages.

OK, but ... why?  What is the externally visible effect of this change?
