Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab1CVUR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:17:57 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55531 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab1CVURn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:17:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=gK/mJPmc93ZBr1DFl/KnTmvHmIsJQAUs7tYKze82zJT1fSwu4V91Gn/xcH0KO0oNN
	OFarVhPyugVEtSNAif8cg==
From: Justin TerAvest <teravest@google.com>
To: vgoyal@redhat.com, jaxboe@fusionio.com
Cc: linux-kernel@vger.kernel.org, Justin TerAvest <teravest@google.com>
Subject: [PATCH 0/2] cfq: Fixes for unaccounted_time variable
Date: Tue, 22 Mar 2011 13:17:28 -0700
Message-Id: <1300825050-11371-1-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should fix both issues that Vivek pointed out:
  * We can't set active queue at preempt time, because select queue
    might select a different queue than the one we chose to preempt.
  * Move the new variable to only be exported when debugging options are
    on.

