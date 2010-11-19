Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279Ab0KSFe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 00:34:56 -0500
Received: from countercultured.net ([209.51.175.25]:44283 "HELO
	countercultured.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750754Ab0KSFez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 00:34:55 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2010 00:34:55 EST
Message-ID: <4CE60AE9.2070101@countercultured.net>
Date: Fri, 19 Nov 2010 00:28:09 -0500
From: David Quigley <merlin@countercultured.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>, Josef Bacik <josef@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sds@tycho.nsa.gov, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] fs: call security_d_instantiate in d_obtain_alias
References: <1290016263-1637-1-git-send-email-josef@redhat.com>	 <20101117191817.GA26575@fieldses.org>	 <20101117192822.GB3818@localhost.localdomain>	 <20101117202617.GA31009@fieldses.org> <1290031941.14282.101.camel@localhost.localdomain>
In-Reply-To: <1290031941.14282.101.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]
> If you have persistent xattr support we need the dentry since the xattr
> code requires a dentry.  I have no idea why but that's what
> inode->i_op->getxattr() requires.
>

The original reason that the xattr operations take dentries is because 
of p9fs and CIFS. CIFS uses the name of the file to grab the extended 
attributes and so does p9fs. I had tried to remove this a while ago but 
couldn't find a way around that. When trying to find a solution I also 
got push back from Miklos (FUSE) as he views a filesystem being able to 
make xattr decisions based on the path name being a valid use-case.

Dave
