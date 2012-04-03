Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab2DCT7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 15:59:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41632 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab2DCT7F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 15:59:05 -0400
Date: Tue, 3 Apr 2012 14:58:44 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Julian Anastasov <ja@ssi.bg>, Len Brown <len.brown@intel.com>,
        Josh Boyer <jwboyer@gmail.com>, wzab@ise.pw.edu.pl,
        stable@vger.kernel.org
Subject: [3.0.y, 3.2.y, 3.3.y] Re: [PATCH 04/76] ACPICA: Fix regression in
 FADT revision checks
Message-ID: <20120403195804.GA19239@burratino>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
 <1333102459-23750-1-git-send-email-lenb@kernel.org>
 <3e80acd1af40fcd91a200b0416a7616b20c5d647.1333101989.git.len.brown@intel.com>
 <CA+5PVA4EBdoxgSrYKYRnaO2qSXDP_rxeQEogD+6jkKPi8sQB-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CA+5PVA4EBdoxgSrYKYRnaO2qSXDP_rxeQEogD+6jkKPi8sQB-g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Josh Boyer wrote:
> On Fri, Mar 30, 2012 at 6:13 AM, Len Brown <lenb@kernel.org> wrote:

>> From: Julian Anastasov <ja@ssi.bg>
>>
>>        commit 64b3db22c04586997ab4be46dd5a5b99f8a2d390 (2.6.39),
>> "Remove use of unreliable FADT revision field" causes regression
>> for old P4 systems because now cst_control and other fields are
>> not reset to 0.
[...]
>>        The fix is to update acpi_gbl_FADT.header.length after
>> the original value is used to check for old revisions.
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=42700
>> https://bugzilla.redhat.com/show_bug.cgi?id=727865
>>
>> Signed-off-by: Julian Anastasov <ja@ssi.bg>
>> Acked-by: Bob Moore <robert.moore@intel.com>
>> Signed-off-by: Len Brown <len.brown@intel.com>
>
> This one should go into the stable trees.

Please apply

  3e80acd1af40 "ACPICA: Fix regression in FADT revision checks"

which is in linus's master to the 3.0.y, 3.2.y, and 3.3.y series to
fix this old boot problem.  (Many affected people disabled HT in the
BIOS to work around it in the meantime.)

WZab (cc-ed) has tested that the patch addresses the problem when
applied to the 3.2.y and 3.3.y branches.  [1] has details.

Thanks,
Jonathan

[1] https://bugzilla.kernel.org/show_bug.cgi?id=38262
