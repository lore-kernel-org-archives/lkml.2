Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695Ab2FFVlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:41:53 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:7149 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758083Ab2FFVlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:41:49 -0400
X-IronPort-AV: E=Sophos;i="4.75,726,1330902000"; 
   d="scan'208";a="161655283"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/7] adjust suspicious bit operation
Date: Wed,  6 Jun 2012 23:41:34 +0200
Message-Id: <1339018901-28439-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches relate to conditional tests where & is used with a constant
that is always 0 and where | is used with a constant that is always 0 or
always non-zero.

The following semantic match finds these problems
(http://coccinelle.lip6.fr/):

@and@
identifier i;
expression e;
position p;
@@

 ((e & i@p) && ...)

@iszera@
identifier and.i;
position p;
@@

#define i 0

@othera@
identifier and.i;
expression e!=0;
@@

#define i e

@script:python depends on iszera && !othera@
p << and.p;
@@

cocci.print_main("",p)

@or@
identifier i;
expression e;
position p;
@@

 ((e | i@p) && ...)


@iszero@
identifier or.i;
position p;
@@

#define i 0

@othero@
identifier or.i;
expression e!=0;
@@

#define i e

@script:python depends on (othero && !iszero) || (iszero && !othero)@
p << or.p;
@@

cocci.print_main("",p)

