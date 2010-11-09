Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273Ab0KIFHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 00:07:21 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33489 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab0KIFHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 00:07:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=Jw6a1X3cpf6csZSw5UGiWfHFclCGKFXKCSNGTZ/g+gJonozvE4aCb1AyRX9qjJYHjE
         nimODOUo831u7t8g2YePLWgNCUWhLIYOH778cQwghJ4b/urOWM9AXOXCrVh0Y/WM3vdR
         sXrAGYSesUOC8OHicyuZrmXUve1B7JBrgRBt0=
MIME-Version: 1.0
From: Luke Hutchison <luke.hutch@gmail.com>
Date: Tue, 9 Nov 2010 00:06:36 -0500
Message-ID: <AANLkTimXSSU7Mc05URg3HsONC4iyDTMVJdRxvQ1fNntH@mail.gmail.com>
Subject: "BUG: soft lockup - CPU#0 stuck for 61s! [kswapd0:184]"
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just wanted to report a bug upstream that is affecting the latest
versions of at least both Fedora and Ubuntu. CPUs somehow lock up
under load, producing errors of the form "BUG: soft lockup - CPU#0
stuck for 61s! [kswapd0:184]"

The Fedora Bug report is here:
https://bugzilla.redhat.com/show_bug.cgi?id=649694 -- however you can
find lots of references to the error message on other distributions
(including Ubuntu) by googling  "bug soft lockup cpu stuck".

Lockups seem to happen on server-class hardware under heavy loads when
the machine is swapping.  This can lead to the entire machine locking
up in some reported cases (although so far only individual CPUs seem
to have locked up in my case, not the entire machine).  The point at
which the CPU hangs varies -- see the dmesg output I attached to the
Fedora bug report above.

My machine is a 12-way Xeon X5680 system with ext3, AFS and XFS
filesystems (XFS is running on hardware RAID).  Please let me know if
you need other info that would be helpful to diagnosing the problem.

Thank you,
Luke Hutchison
