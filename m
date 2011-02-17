Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab1BQXJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 18:09:21 -0500
Received: from cobra.newdream.net ([66.33.216.30]:58355 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab1BQXJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 18:09:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=Yuq+KCvZGAMHrdob/o7/6goZ6e71DUKezFdRwv4OfAjmPd3Z
	6YyF/TLmUgGecyfvSCrpg5ZC4I+iTx0/EBz0Ohi1HhsOg/sV56Z4fTrABMuI8c1F
	ETKpQ4snMw+2s7+FU24N3Egy/tDMlKeZLxBH9j96Q5DTNjE2bMpbCnDyZPQ=
Date: Thu, 17 Feb 2011 15:10:39 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: npiggin@gmail.com
cc: viro@zeniv.linux.org.uk, Trond.Myklebust@netapp.com,
        yehuda.sadeh@dreamhost.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: NULL d_parent and ceph, nfs sillyrename regressions
Message-ID: <Pine.LNX.4.64.1102171121450.18322@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

Any progress of fixing the d_parent behavior that's breaking ceph and 
sillyrename?  Just a reminder: ceph currently oopses on d_kill, and 
sillyrename entries don't go away.  Your message from 3 weeks ago 
suggested the fix was relatively simple and imminent, but it's getting 
late in the cycle and I'm getting nervous :).

We do have an ugly hack[1] that will fix the ceph problem (by making a 
copy of d_parent in the d_fsdata struct), but I'd obviously rather not 
push that.

FWIW the d_parent clearing in d_kill was introduced by 949854d0.

Thanks!
sage


[1] http://ceph.newdream.net/git/?p=ceph-client.git;a=commitdiff;h=9c3db357aa3de6fd5e3ef2865e20848251aa05a4
