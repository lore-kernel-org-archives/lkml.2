Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab0H3Qp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 12:45:56 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41226 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab0H3Qpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 12:45:55 -0400
MIME-Version: 1.0
X-Originating-IP: [192.94.94.105]
Date: Mon, 30 Aug 2010 11:45:53 -0500
Message-ID: <AANLkTi==im4bxnn9Ga2-ukUCiKdzQETHahcgvEj0Sef6@mail.gmail.com>
Subject: usage of kill_pid and family
From: Pavan Savoy <pavan_savoy@sify.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I use kill_pid in one of our drivers to signal a user-space daemon to
perform a particular action (open-UART for instance), I recently ran
into problems with permissions as to when a user with stranger UID
started open up a device, which internally calls the kill_pid in that
context, could not send the signal and returned with "permission
denied".

I started using kill_pid_info_as_uid and sent signals as UID 0 to
solve the problem, it did solve the problem, but is this the right
approach?

Also why is not suggested to use kill_pid and family to communicate
with user-space? (namespace issues??- what do they mean?)

Note:
I get the PID of the process which receives signal from one of the
sysfs entries created by driver, but filled up by the daemon...
