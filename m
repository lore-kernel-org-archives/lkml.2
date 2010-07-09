Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab0GISnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 14:43:07 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:49040 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab0GISnE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 14:43:04 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=kfmJinPqzyUA:10 a=1CvaPgNKC-EA:10 a=VphdPIyG4kEA:10
 a=kj9zAlcOel0A:10 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=VnNF1IyMAAAA:8
 a=e--v2E7seF_T0D39w2UA:9 a=O6-lKtWIugHkKau7EnbWSs-ltyEA:4 a=CjuIK1q_8ugA:10
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle syscalls
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20100708222121.5c0612ef@notabene.brown>
Date: Fri, 9 Jul 2010 12:42:42 -0600
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
       Christoph Hellwig <hch@infradead.org>,
       "viro@zeniv.linux.org.uk Viro" <viro@zeniv.linux.org.uk>,
       "corbet@lwn.net Corbet" <corbet@lwn.net>,
       "hooanon05@yahoo.co.jp Okajima" <hooanon05@yahoo.co.jp>,
       linux-fsdevel@vger.kernel.org,
       "sfrench@us.ibm.com French" <sfrench@us.ibm.com>,
       "philippe.deniel@CEA.FR Deniel" <philippe.deniel@CEA.FR>,
       "linux-kernel@vger.kernel.org Mailinglist" 
	<linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <5DF5C974-092B-4CE6-B11D-2DBB73782149@dilger.ca>
References: <20100706161002.GD7387@fieldses.org> <87eifgfsez.fsf@linux.vnet.ibm.com> <20100706232351.GD25018@dastard> <20100707093629.10c2feab@notabene.brown> <20100707021150.GF25018@dastard> <20100707125726.3695587a@notabene.brown> <20100707125701.GA19872@fieldses.org> <E1OWUOL-0004DM-Ul@pomaz-ex.szeredi.hu> <20100707131721.GB19872@fieldses.org> <E1OWUn0-0004JI-7F@pomaz-ex.szeredi.hu> <20100707144511.GA24360@fieldses.org> <20100708082143.3701bfc7@notabene.brown> <87wrt6dzp2.fsf@linux.vnet.ibm.com> <20100708222121.5c0612ef@notabene.brown>
To: Neil Brown <neilb@suse.de>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-08, at 06:21, Neil Brown wrote:
> On Thu, 08 Jul 2010 16:10:09 +0530
> "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
>> How about adding mnt_id to the handle ? Documentation file says it is unique 
>> 
>> (1) mount ID:  unique identifier of the mount (may be reused after umount)

But this value is not persistent across a reboot, or even an umount/mount so it is not useful as an identifier.

I suppose one way to resolve this issue is to just allow the underlying filesystem to supply a completely opaque filehandle to userspace.  For local filesystems that don't care about persistence or uniqueness between nodes they can use something like mount_id, and for distributed/clustered filesystems they can include a globally-unique identifier.

Cheers, Andreas





