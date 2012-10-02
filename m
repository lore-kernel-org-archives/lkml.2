Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab2JBWeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:34:22 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23024 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab2JBWeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:34:20 -0400
To: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@zabbo.net>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tytso@google.com, tj@kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        michael.mesnier@intel.com, jeffrey.d.skirvin@intel.com,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [RFC, PATCH] Extensible AIO interface
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20121001222341.GF26488@google.com>
	<20121001231222.GB14533@lenny.home.zabbo.net>
	<20121001232235.GH26488@google.com>
Date: Tue, 02 Oct 2012 18:34:05 -0400
In-Reply-To: <20121001232235.GH26488@google.com> (Kent Overstreet's message of
	"Mon, 1 Oct 2012 16:22:35 -0700")
Message-ID: <yq1sj9w33mq.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Kent" == Kent Overstreet <koverstreet@google.com> writes:

>> Hmm, careful here.  I think that in DIF/DIX the checksums are
>> per-sector, not per IO, right?  That'd mean that the PAGE_SIZE attr
>> limit in this patch would be magically creating different max IO size
>> limits on different architectures.  That doesn't seem great.

Kent> Not just per sector, Per hardware sector. 

Per logical block (or for some devices less).


Kent> For passing around checksums userspace would have to find out the
Kent> hardware sector size and checksum type/size via a different
Kent> interface,

The relevant information is already exported in sysfs. Including the
format, how many bytes of integrity metadata go with how many bytes of
data, etc.

-- 
Martin K. Petersen	Oracle Linux Engineering
