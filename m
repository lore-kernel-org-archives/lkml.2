Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab1EYU1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:27:24 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:52712 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab1EYU1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:27:23 -0400
Date: Wed, 25 May 2011 22:27:21 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [bisected] Strange slowdowns timerfd related
Message-ID: <20110525202721.GA1738@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've tested the latest git-kernel today and did experience long delays
in Firefox. Just opening a new tab would take a few seconds and after
typing a few characters into the "awesome bar" I would have to wait ages
before the results were shown.

This is the bisection result:

 commit 9ec2690758a5467f24beb301cca5098078073bba
 Author: Thomas Gleixner <tglx@linutronix.de>
 Date:   Fri May 20 16:18:50 2011 +0200

     timerfd: Manage cancelable timers in timerfd

Reverting the commit above fixes the problem.
-- 
Markus
