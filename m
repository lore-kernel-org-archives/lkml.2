Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab2BWLke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 06:40:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab2BWLkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 06:40:33 -0500
Message-ID: <4F4625A2.2030401@redhat.com>
Date: Thu, 23 Feb 2012 09:40:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: edac-devel <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>
Subject: latest version of the HERM patches
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed previously, the HERM (Hardware Events Report Mecanism)
patches are changing the EDAC/MCE internals, in order to provide
a consistent way of reporting hardware errors, and it is the result
of the discussions during the EDAC meetings:

	http://lwn.net/Articles/388292/
	http://lwn.net/Articles/416669/

The changes there consist of:
	- abstracting the memory architecture used by EDAC;
	- provide a proper representation for FB-DIMM memories;
	- add a test mechanism for the error core and applications;
	- add trace events do describe the hardware errors.

We're having a bad time to reach an agreement about the proper
trace format. So, I've rebased my patches to let the trace changes
to happen on a single patch, at the end of the series, and put them
at:
	http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commit;h=b743397622ea1847b622f691bd44344f735b44d1

The content there is basically the same as the last patch series I've
proposed, except for one small change: I renamed the internal struct
"dimm_info" to "memset_info". The rationale for it is that the content
of that struct can be a dimm or a rank, depending on the driver. So,
"memory set" is a better name for such struct.

I preserved there the same trace struct as on my last proposal
because we didn't reach an agreement. After having such agreement,
there's just one independent patch that needs to be changed or
replaced.

This also makes easier to propose a different way, as the patches that
abstract the memory hierarchy also replaces all error calls at edac by
a single function call: edac_mc_handle_error(). So, there's a single
point where the trace call should be added.

Also, as I'm running a test on several different EDAC hardware to check
if the internal changes at the structs didn't break anything,
it also prevents the need to re-test everything, as only the EDAC
core would be affected by a trace change.

Regards,
Mauro
