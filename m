Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab1FXMIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 08:08:39 -0400
Received: from mail-bw0-f52.google.com ([209.85.214.52]:48135 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab1FXMIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 08:08:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=b8G6MfYLJu1DlBDccQF9DGLkPzxgFVZLACkskKZaz6Qqg2AWT+E5VAf34/YfvWbQOH
         8nyroNlo7oBmoSPedBJ9x/sRikG0y0hBTKFnMV+zOBFYeNHDK+4BBW9exPnwR74JKO9d
         j3jnTS8ZuRowcFcF6zkIpVC6ERHCxRUP0A330=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, security@kernel.org,
        Eric Paris <eparis@redhat.com>, Solar Designer <solar@openwall.com>
Subject: [PATCH 0/2] restrict statistics information to user
Date: Fri, 24 Jun 2011 16:07:54 +0400
Message-Id: <1308917274-4701-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

taskstats and /proc/PID/io may be used for gathering private
information.  E.g. for openssh and vsftpd daemons wchars/rchars may be
used to learn the precise password length (pass_len = w_chars - CONST).
Restrict it to user.

The simplified proof learning whether ~*/.ssh/authorized_keys file
exists is posted here:
http://www.openwall.com/lists/oss-security/2011/06/21/12

Vasiliy Kulikov (2):
  proc: restrict access to /proc/PID/io
  taskstats: restrict access to user

 fs/proc/base.c     |    7 +++++--
 kernel/taskstats.c |   23 ++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 3 deletions(-)

