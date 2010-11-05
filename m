Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab0KEWdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 18:33:53 -0400
Received: from karen.lavabit.com ([72.249.41.33]:39658 "EHLO karen.lavabit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947Ab0KEWdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 18:33:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=lavabit; d=lavabit.com;
  b=GwAlYPDDF91gUhWkiRzczyq7lASqOcoLF67hts5UTgfZd2tQL4kPLJO0edIF7NGtPgmSvqCmE0+8kXqtgjRkBIaXGpI243tetf5XuB9GWUHzqis9qOkhpcXnLlOWr3M3oVp/OCmGXHUggalh3dZimKjA/O2FdeZ2dlhHPMratMA=;
  h=Content-Type:Reply-To:To:Subject:Date:MIME-Version:Content-Transfer-Encoding:From:Message-ID:User-Agent;
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Reply-To: abirvalg@lavabit.com
To: linux-kernel@vger.kernel.org
Subject: procfs doesnt honor cap_dac_override
Date: Fri, 05 Nov 2010 18:33:45 -0400
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: abirvalg@lavabit.com
Message-ID: <op.vlpyahbg25uvhe@wwwwww-701sd>
User-Agent: Opera Mail/10.60 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a folder /proc/1/fd which contains symlinks.
A superuser can do readlink() on those symlinks.
I expected that a non-root process with cap_dac_override capability set to  
EP could also readlink() those symlinks in /proc/1/fd, but alas  
"Permission denied".
Just to make sure that my process isn't the culprit, I ran it as a regular  
user with UID=1000, I set cap_dac_override=ep and navigated to /root  
folder (which is readable only by root) and did readlink() there. It  
worked. (/root folder is on ext4.)
Bottom line: procfs doesnt allow readlink() on certain symlinks owned by  
root even with cap_dac_override set.

Is this an expected behaviour or is this a bug?
Cheers.

