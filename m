Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223Ab0JGJND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 05:13:03 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:60867 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab0JGJNA convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:1:1>);
	Thu, 7 Oct 2010 05:13:00 -0400
Message-Id: <4CADAB3A020000780001B30A@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 07 Oct 2010 10:12:58 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: patch disabling use of PSE on Atom CPUs with a certain erratum
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 7a0fc404ae663776e96db43879a0fa24fec1fa3a you
disable use of PSE, but I wonder how this can take any effect on
64-bit CPUs, as they use large pages during early boot already.
Those pages, when use of PSE gets disabled, will get broken up
into 4k pages in phys_pmd_init(), thus actually increasing the
chances that you hit the erratum.

What am I missing?

Jan

