Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab1K1JHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 04:07:48 -0500
Received: from tus1smtoutpex01.symantec.com ([216.10.195.241]:64211 "EHLO
	tus1smtoutpex01.symantec.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753210Ab1K1JHn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 04:07:43 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Nov 2011 04:07:43 EST
X-AuditID: d80ac3f1-b7fae6d0000026bf-e0-4ed34e32e0f5
From: Wen Yan Xin <WenYan_Xin@symantec.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Zongliang Li <Zongliang_Li@symantec.com>, Gang He <Gang_He@symantec.com>,
        Yong Jun Chai <YongJun_Chai@symantec.com>
Date: Mon, 28 Nov 2011 01:03:07 -0800
Subject: what's the replace for the big kernel lock after kernel version
 2.6.39 for system call.
Thread-Topic: what's the replace for the big kernel lock after kernel
 version 2.6.39 for system call.
Thread-Index: AcyrU/YiIsISdx0XRBquy8hmDQw7lwAAOf8wAJXOidA=
Message-ID: <F0BE05962279964D949D53875492E2E24FC27D7C30@APJ1XCHEVSPIN32.SYMC.SYMANTEC.COM>
References: <S1752501Ab1KYJXy/20111125092354Z+1871@vger.kernel.org> 
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: AVec AtUq AwKd A4AW BEv+ DCdI EKoj GSvj HNfz HObI Hq5A
 ITz4 I17X JMLo JmhV
 KE5g;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{193A4F9D-5A16-46BC-9D65-F84D7647AC6F};dwBlAG4AeQBhAG4AXwB4AGkAbgBAAHMAeQBtAGEAbgB0AGUAYwAuAGMAbwBtAA==;Mon,
 28 Nov 2011 09:03:07
 GMT;dwBoAGEAdAAnAHMAIAB0AGgAZQAgAHIAZQBwAGwAYQBjAGUAIABmAG8AcgAgAHQAaABlACAAYgBpAGcAIABrAGUAcgBuAGUAbAAgAGwAbwBjAGsAIABhAGYAdABlAHIAIABrAGUAcgBuAGUAbAAgAHYAZQByAHMAaQBvAG4AIAAyAC4ANgAuADMAOQAgAGYAbwByACAAcwB5AHMAdABlAG0AIABjAGEAbABsAC4A
x-cr-puzzleid: {193A4F9D-5A16-46BC-9D65-F84D7647AC6F}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVyYMX1NF0jv8t+Bi9ey1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MLdOusxdcY63Y1NnL1sC4l6WLkZNDQsBE4t2uJihbTOLCvfVs
	XYxcHEICHxklpr18wArhdDNJnHzZzQzhrGCUuHNoLSNIC5uAtkT78u3MILaIgKPEjoNf2UBs
	ZoFKiS//e9lBbBYBVYktrdOZQGxhgSSJ+RcXskDUp0tc33sHqtdK4sn9ZjCbVyBKYsO3p2D1
	QgIuEl8nPAWLMwKd9/3UGiaI+eISc6fNYoU4W0BiyZ7zzBC2qMTLx//ArpYQ2MIi8er/GUaI
	hKnEq/abrBCDRCXutK9nhBikI7Fg9yeoo7Ulli18DXWEoMTJmU9YJjBKzEKybxaSlllIWmYh
	aVnAyLKKUaaktNiwOLckv7SkILXCwFCvuDI3ERhpyXrJ+bmbGIHRdoPr8McdjNeXKh5iFOBg
	VOLhvet82U+INbEMqPIQowQHs5IIb8/RS35CvCmJlVWpRfnxRaU5qcWHGKU5WJTEeStmbfIT
	EkhPLEnNTk0tSC2CyTJxcEo1MErX+7HHzb006ZrK8lP2mas/WpdwLrsgsGef29bOMO/crsyf
	rVrfNlR/jiyZvC1wcbOnwUQWg/UubqI3XFeKXbW8HfmL+aiL45syV73LYdqTA5yNPuUfC/7t
	32BveSd7wdoHVi+7j37bH6FdcutFmevMqT9tk4XNhDv7p/YaSGqFnThuz+LhpcRSnJFoqMVc
	VJwIAIgTlzWyAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have a trouble of working on kernel 2.6.39 and later. Originally when our kernel module startups, it hooks some file system call, like sys_open... , and the big kernel lock - lock_kernel() - will be held before creating the hook to prevent user application use system calls, and be released after the hook created.


But after the kernel 2.6.39, the big kernel lock has been removed. I'm thinking there should be one or more lock that should be used. 

So, my question is which lock should be held now, when we hook the system call of file system?

I'd really appreciate your answer in advance.


--

>>>> 	auth ca64a8ac subscribe linux-kernel wenyan_xin@symantec.com
Succeeded.
