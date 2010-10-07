Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab0JGRRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:17:40 -0400
Received: from smtp.srv.ualberta.ca ([129.128.5.19]:60922 "EHLO
	mail6.srv.ualberta.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751861Ab0JGRRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:17:39 -0400
Date: Thu, 7 Oct 2010 11:17:43 -0600 (Mountain Daylight Time)
From: Marc Aurele La France <tsi@ualberta.ca>
Reply-To: linux-kernel@vger.kernel.org, tsi@ualberta.ca
To: linux-kernel@vger.kernel.org
Subject: x86_64 2.6.35.* kernels and Intel Xeon X5550
Message-ID: <alpine.WNT.2.00.1010071055420.1672@cluij.ucs.ualberta.ca>
User-Agent: Alpine 2.00 (WNT 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings.

I administer a cluster composed of a mixture of various Opteron models and 
Intel Xeon X5550's.  The 2.6.34.*, and prior, kernels run fine on all of 
them.  The 2.6.35 series also runs fine on the Opterons, but not on the 
Xeon's.  All of these are CONFIG_GENERIC_CPU kernels.

On the Xeon's, 2.6.35 hangs early on, upon the first test of trace events 
(in kernel/trace/trace_events.c:event_trace_self_tests()).  When disabling 
all tracing, debugging, etc., it still hangs but slightly later.  The 
megaraid_sas module is loaded, detects the adapter, but never gets around 
to registering it with the SCSI layer.

Core2-specific kernels also hang the same way, as do UP kernels.  I've 
tried backing out certain commits that seemed likely candidates, but have 
yet to stumble upon the one (or more) that is causing this.

Does anyone have any ideas?

Thanks.

Marc.

+----------------------------------+----------------------------------+
|  Marc Aurele La France           |  work:   1-780-492-9310          |
|  Academic Information and        |  fax:    1-780-492-1729          |
|    Communications Technologies   |  email:  tsi@ualberta.ca         |
|  352 General Services Building   +----------------------------------+
|  University of Alberta           |                                  |
|  Edmonton, Alberta               |    Standard disclaimers apply    |
|  T6G 2H1                         |                                  |
|  CANADA                          |                                  |
+----------------------------------+----------------------------------+
