Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab2KSLi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 06:38:28 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34922 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab2KSLi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 06:38:26 -0500
Message-ID: <50AA1A2A.2070504@redhat.com>
Date: Mon, 19 Nov 2012 12:38:18 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
CC: Christoph Hellwig <hch@lst.de>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Christoph Hellwig <hch@infradead.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] target/iblock: Add WRITE_SAME w/ UNMAP=0 emulation
 support
References: <1352405238-23267-1-git-send-email-nab@linux-iscsi.org> <1352405238-23267-4-git-send-email-nab@linux-iscsi.org> <20121115110432.GD28956@infradead.org> <1353007786.4447.29.camel@haakon2.linux-iscsi.org> <20121115193235.GA5714@lst.de> <94D0CD8314A33A4D9D801C0FE68B40294CCF8D45@G9W0745.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40294CCF8D45@G9W0745.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 15/11/2012 21:01, Elliott, Robert (Server Storage) ha scritto:
> WRITE SAME always has a payload, regardless of the UNMAP bit value.
> 
> For WRITE SAME with UNMAP=0, it's extremely important; that's how
> what to write is specified.
> 
> For WRITE SAME with UNMAP=1, the device server is required to check
> that the payload matches the data that is returned for unmapped LBAs.
> lf LBPRZ=1 (read zeros for unmapped LBAs), that means checking that
> the payload has all zeros.  In sbc3r33, this rule is tucked away in
> model section 4.7.3.4.3, not the command section 5.41.

Does that mean that LBPRZ=0, LPBWS=1 is practically an invalid
combination?  Because there's no real way for the device server to
perform the check successfully.

Paolo

> I would like to change that rule (it's a nuisance and a performance
> burden), but that's the current rule going into SBC-3 letter ballot.
> 
> Changing WRITE SAME with UNMAP=1 to ignore the payload would provide
> essentially the same functionality as changing the UNMAP command to
> be mandatory, not just a hint; both approaches have been discussed.
