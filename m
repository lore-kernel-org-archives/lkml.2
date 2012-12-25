Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab2LYQok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 11:44:40 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:43244 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab2LYQoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 11:44:38 -0500
Date: Tue, 25 Dec 2012 08:44:33 -0800
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 11/25] pm: don't use [delayed_]work_pending()
Message-ID: <20121225164433.GG10220@mtj.dyndns.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-12-git-send-email-tj@kernel.org>
 <1652427.IL3F6yol0I@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1652427.IL3F6yol0I@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On Sat, Dec 22, 2012 at 12:53:29PM +0100, Rafael J. Wysocki wrote:
> On Friday, December 21, 2012 05:57:01 PM Tejun Heo wrote:
> > There's no need to test whether a (delayed) work item in pending
> > before queueing, flushing or cancelling it.  Most uses are unnecessary
> > and quite a few of them are buggy.
> 
> Can you please say why they are buggy?

Usually one of the following two reasons.

* The user gets confused and fails to handle !PENDING && currently
  executing properly.

* work_pending() doesn't have any memory barrier and the caller
  assumes work_pending() is somehow properly synchronized by itself.

Thanks.

-- 
tejun
