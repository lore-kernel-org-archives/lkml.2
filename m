Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab0GHLxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 07:53:19 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50848 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab0GHLxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 07:53:18 -0400
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
CC: neilb@suse.de, bfields@fieldses.org, miklos@szeredi.hu,
       david@fromorbit.com, hch@infradead.org, viro@zeniv.linux.org.uk,
       adilger@sun.com, corbet@lwn.net, serue@us.ibm.com,
       hooanon05@yahoo.co.jp, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
In-reply-to: <87wrt6dzp2.fsf@linux.vnet.ibm.com>
	(aneesh.kumar@linux.vnet.ibm.com)
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle syscalls
References: <20100706161002.GD7387@fieldses.org> <87eifgfsez.fsf@linux.vnet.ibm.com> <20100706232351.GD25018@dastard> <20100707093629.10c2feab@notabene.brown> <20100707021150.GF25018@dastard> <20100707125726.3695587a@notabene.brown> <20100707125701.GA19872@fieldses.org> <E1OWUOL-0004DM-Ul@pomaz-ex.szeredi.hu> <20100707131721.GB19872@fieldses.org> <E1OWUn0-0004JI-7F@pomaz-ex.szeredi.hu> <20100707144511.GA24360@fieldses.org> <20100708082143.3701bfc7@notabene.brown> <87wrt6dzp2.fsf@linux.vnet.ibm.com>
Message-Id: <E1OWpeX-0006V3-Cl@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 08 Jul 2010 13:52:29 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Jul 2010, Aneesh Kumar K. V wrote:
> How about adding mnt_id to the handle ? Documentation file says it is
> unique 
> 
> (1) mount ID:  unique identifier of the mount (may be reused after umount)
> 
> I also updated (/proc/self/mountinfo) to carry the optional uuid field
> With the below patch i get  in /proc/self/mountinfo
> 
> 13 1 253:0 / / rw,relatime,uuid:9b5af62a-a34a-43f6-a5bb-1cc22d97e862 - ext3 /dev/root rw,errors=continue,barrier=0,data=writeback
> 
> And the handle returns the value 13 in mnt_id field. We should able to
> lookup mountinfo with mnt_id and find the corresponding uuid.
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 88058de..498bd9a 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -871,6 +871,9 @@ static int show_mountinfo(struct seq_file *m, void *v)
>  	if (IS_MNT_UNBINDABLE(mnt))
>  		seq_puts(m, " unbindable");
>  
> +	/* print the uuid */
> +	seq_printf(m, ",uuid:%pU", mnt->mnt_sb->s_uuid);
> +

This should be

	seq_printf(m, " uuid:%pU", mnt->mnt_sb->s_uuid);

Thanks,
Miklos
