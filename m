Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934089Ab0EYUKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 16:10:11 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55906 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933673Ab0EYUKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 16:10:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 25 May 2010 22:10:03 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: powernow-k8: section mismatch
To: cpufreq@vger.kernel.org
cc: Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Message-ID: <tkrat.97946ecfb316e3af@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got the following with current git:

    WARNING: arch/x86/kernel/cpu/cpufreq/powernow-k8.o(.exit.text+0x1c): Section mismatch in reference from the function cleanup_module() to the variable .cpuinit.data:cpb_nb                      
    The function __exit cleanup_module() references                                                 
    a variable __cpuinitdata cpb_nb.                                                                
    This is often seen when error handling in the exit function                                     
    uses functionality in the init path.                                                            
    The fix is often to remove the __cpuinitdata annotation of                                      
    cpb_nb so it may be used outside an init section.                                               

Looks like it was introduced by
"powernow-k8: Add core performance boost support".
-- 
Stefan Richter
-=====-==-=- -=-= ==--=
http://arcgraph.de/sr/

