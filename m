Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab1BAI2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 03:28:05 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:56783 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab1BAI2E convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:2:1>);
	Tue, 1 Feb 2011 03:28:04 -0500
Message-Id: <4D47D21E020000780002F9FB@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 01 Feb 2011 08:27:58 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Michael Galbraith" <MGalbraith@novell.com>
Subject: calling smp_call_function_many() with non-stable CPU mask
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a couple of examples of smp_call_function_many() getting
called with mm_cpumask() as the first argument. Since that mask
generally can change while smp_call_function_many() is executing,
it seems there might be a problem with the case where that mask
becomes empty after the initial checks, but before the mask is made
permanent (by copying into data->cpumask).

Shouldn't there be a check of data->refs being zero right after
setting it (to avoid having csd_lock_wait() wait for a remote CPU
to clear the lock flag, and to avoid adding the entry to
call_function.queue)?

If that isn't considered necessary, is it then incorrect to pass
in-flight CPU masks to smp_call_function_many() (and should
this requirement then be documented somewhere, and the
existing calls all be inspected for correctness)?

Thanks, Jan

