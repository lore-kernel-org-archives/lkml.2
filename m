Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab2AEODi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:03:38 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:30896 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab2AEODh convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 5 Jan 2012 09:03:37 -0500
Message-Id: <4F05BBFE020000780006A983@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 05 Jan 2012 14:04:30 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, <linux-kernel@vger.kernel.org>
Subject: x86-64: memset()/memcpy() not fully standards compliant
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forever these two functions have been limited to deal with at most 4G
at a time. While I cannot point out an in-tree user that would require
larger sizes, it is now the second time that within our Xen kernel we got
bitten by that limitation. Would you nevertheless accept a patch to
eliminate those shortcomings (iirc there may need to be workarounds
for CPU bugs when it comes to using string instructions on such large
blocks, albeit memmove() doesn't seem to care)?

Otherwise, is there any rationale for this sort of lurking bug?

Thanks, Jan

