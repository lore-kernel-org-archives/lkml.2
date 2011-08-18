Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab1HRGP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 02:15:27 -0400
Received: from shawmail.shawcable.com ([64.59.128.220]:15211 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab1HRGPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 02:15:25 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=rhzBfl3TH6jSClqh7E8qe//hARbvbzCI0ETuu7/2kJU= c=1 sm=1
 a=rlxT3IFZqTIA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=k8hqzbHzjweV03hO1KKrVA==:17 a=VnNF1IyMAAAA:8 a=bOuLOLSVyyhXJqChc6oA:9
 a=CjuIK1q_8ugA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
X-IronPort-AV: E=Sophos;i="4.68,243,1312178400"; 
   d="scan'208";a="584625037"
X-reinject: true
References: <20110817032519.GN20655@tux1.beaverton.ibm.com>
In-Reply-To: <20110817032519.GN20655@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <EB5DDA28-421A-4C67-817C-74F9B9643351@dilger.ca>
Content-Transfer-Encoding: 8BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Sunil Mushran <sunil.mushran@oracle.com>,
        Joel Becker <jlbec@evilplan.org>, Mingming Cao <cmm@us.ibm.com>,
        Amir Goldstein <amir73il@gmail.com>, Coly Li <colyli@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
X-Mailer: iPhone Mail (8L1)
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC] ext4 metadata checksumming design
Date: Thu, 18 Aug 2011 00:16:00 -0600
To: "djwong@us.ibm.com" <djwong@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-16, at 9:25 PM, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> - Extended attribute blocks that are stored in the inode table -- the h_magic
>  field is written by the kernel, but neither the kernel nor e2fsprogs ever
>  actually read this field.  The field could be reused to checksum the extra
>  space since (as far as I can tell) EAs are the only user of that empty space.

I haven't had a chance to read the document you wrote, but wanted to comment on xattrs. There is a hash field for each xattr (including internal xattrs), and one for the external xattr blocks that can be used to validate the xattr value.

In addition to the hash for the in-inode xattrs, the inode hash itself would serve to validate the xattr values. 

I have a patch for e2fsprogs that checks the xattr hash for in-inode xattrs (currently it is always 0).

> Please have a look at the design document and please feel free to suggest any
> changes.

Hopefully soon. 

Cheers, Andreas