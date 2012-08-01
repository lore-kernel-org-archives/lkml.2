Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab2HAXQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 19:16:40 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35292 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab2HAXQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 19:16:38 -0400
Message-ID: <5019B8B1.7090902@linux.vnet.ibm.com>
Date: Wed, 01 Aug 2012 16:16:01 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Marian Beermann <public@enkore.de>
CC: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] NTFS code doesn't sanitize folder names sufficiently
References: <501189DA.4030709@enkore.de>
In-Reply-To: <501189DA.4030709@enkore.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080123-2398-0000-0000-0000090DE5C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The solution to this would be to disallow creation of files and
> folders on NTFS drives containing illegal characters.

Illegal characters with respect to Windows & the like are different 
from Illegal characters with respect to the NTFS filesystem structure.

Looking at ntfs-3g(8) [yes, I'm aware that is a different driver that 
this bug is about], the section on Windows Filename Compatability says 
this:

       [...] all characters are
       allowed except '/' and '\0'. This is perfectly legal on Windows, 
though some application may get
       confused. The option windows_names may be used to apply Windows 
restrictions to new file names.

To recap: no data will be lost due to using '\' in filenames. Some 
operating systems just may not be capable off accessing it.

--
Cody

