Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab0JFKeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 06:34:17 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:14964 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587Ab0JFKeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 06:34:15 -0400
X-SpamScore: -7
X-BigFish: VS-7(zzzz1202hzz8275bh5eeePz32i87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L9V6OR-02-5FB-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] apic, x86: Use BIOS settings to setup AMD EILVT APIC registers
Date: Wed, 6 Oct 2010 12:27:52 +0200
Message-ID: <1286360874-1471-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set changes the way of setting up EILVT APIC registers
(APIC500-530). See family 10h bkdg:

 http://support.amd.com/us/Processor_TechDocs/31116.pdf

Until now, Linux has assigned fixed LVT offsets for IBS and MCE
threshold. With the introduction of new cpu families we want to be
more flexible and assign those LVT offsets dynamically. The general
apporach here is to let the BIOS decide which offsets to use. Linux
will then detect this by reading the corresponding hw registers that
contain the LVT offsets.

This requires to check if the BIOS is correctly setting up the LVT
offsets. Otherwise a firmware bug message will be thrown. This is
implemented in patch #1.

Patch #2 implements the detection of MCE threshold and IBS LVT offsets
and changes the subsystem initialization. The code to setup the IBS
LVT offset on family 10h systems will remain as a workaround that will
be only applied in case of an invalid IBS LVT BIOS setup.

-Robert


