Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab1DQOGH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 10:06:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39898 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1DQOGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 10:06:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=vNHv/etXoLnFtBT+SrGnIJq0GxFwMgGQyNbqs87H2pzUrog9PGsIZyFI4HhPoZrst0
         op5AmtDtYnfZVQRUA4FJkcWU5Wl0MMojGfVGVkiE4u4HQF0Yd9CiDgIYXPzn8DhquRn8
         rjGJYrRMGGuK3I2iDZpFmEDbYK1P3fEFiQH9w=
MIME-Version: 1.0
Date: Sun, 17 Apr 2011 23:05:59 +0900
Message-ID: <BANLkTikTxCFHs2xb4b5QFQp3SJAEjgyRJg@mail.gmail.com>
Subject: Linux capabilities shouldn't be lost during setuid to non-root from
 root or to another non-root uid from a non-root uid.
From: crocket <crockabiscuit@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux capabilities exist to split root previlege to dozens of subsets
of previleges.
But after setuid, all linux capabilities gained from a file are gone for good.
This becomes a problem with OpenVPN.

If I use --mlock option and --user option in OpenVPN, OpenVPN locks
memory with mlockall as root and drops to a non-root user specififed
by --user option.
After dropping to a non-root user, the process loses CAP_IPC_LOCK
capability gained from OpenVPN executable which I personally set.
Because the process doesn't have CAP_IPC_LOCK capability and its UID
isn't 0, further attempts to allocate memory more than "ulimit -l" to
openvpn crash OpenVPN.
This defeats the purpose of linux capabilities.
Linux capabilities exist to give a subset or subsets of previleges to
processes whose UID is greater than 0(root).

Can somebody provide or merge a patch that prevents linux from losing
capabilities after setuid?
