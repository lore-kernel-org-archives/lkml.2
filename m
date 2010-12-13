Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab0LMLiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 06:38:00 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65502 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab0LMLh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 06:37:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=KEBFMDe00PSrD+g4exZM9MleNoOIyuPYvoNYPNtEs0rDFN4sTwHtChPWaIFirrxq7o
         4Z5ugr8AyMSexs0YNTLaptZyoqj5Q8z0h4xlaobzospzaTHhGUomfp7hFxlb6cchzXSO
         QFCu963n0fcLuiwijNJgQVUDJ9VKUJhMbI5NE=
Date: Mon, 13 Dec 2010 14:37:45 +0300
From: Dan Carpenter <error27@gmail.com>
To: jeffm@suse.com
Cc: linux-kernel@vger.kernel.org, brian@xyzw.org, balbir@in.ibm.com
Subject: delayacct: alignment changes break iotop
Message-ID: <20101213113745.GE1620@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>, jeffm@suse.com,
	linux-kernel@vger.kernel.org, brian@xyzw.org, balbir@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Iotop uses hardcoded offsets to find the taskstats struct members.
This got changed in 2.6.37 so it now iotop doesn't work on amd64.  The
offending commit is:

commit 85893120699f8bae8caa12a8ee18ab5fceac978e
Author: Jeff Mahoney <jeffm@suse.com>
Date:   Wed Oct 27 15:34:43 2010 -0700

    delayacct: align to 8 byte boundary on 64-bit systems

Brian Rogers gets the reported-by tag.  The bugzilla entry is:
https://bugzilla.kernel.org/show_bug.cgi?id=24272

regards,
dan carpenter
