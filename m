Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab0CXS0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:26:36 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:52942 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab0CXS0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:26:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OMI/G8I2zGb8qF0oojrLxFVKjR+6DwdyGhLHD2Mxs1JW8qmi/l+PBS+SnZ0+2fuxEI
         fcg48/4tjb3XjmFfIXtM4oc9NFbp7JKcCtMt4/Zh5d7PhEVxVy7gLgoqsi/wtheF0CwJ
         QEys0eT/S4lpcFf6GGs8w29evyvV6SqeWWoYY=
Message-ID: <4BAA5955.4000001@gmail.com>
Date: Wed, 24 Mar 2010 14:26:29 -0400
From: Doug Nazar <nazard.lkml@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Boaz Harrosh <bharrosh@panasas.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
References: <4BAA3493.1030802@panasas.com> <20100324160037.GP30031@ZenIV.linux.org.uk> <4BAA3828.2070506@panasas.com> <20100324160754.GQ30031@ZenIV.linux.org.uk> <4BAA398C.5050901@panasas.com> <20100324163948.GR30031@ZenIV.linux.org.uk> <4BAA48A3.1030801@panasas.com> <4BAA4CAC.6060104@panasas.com> <4BAA5035.1060906@panasas.com> <4BAA52A8.2080304@panasas.com> <20100324180622.GS30031@ZenIV.linux.org.uk>
In-Reply-To: <20100324180622.GS30031@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-03-24 2:06 PM, Al Viro wrote:
>
> How consistent are the effects you are seeing from test to test on the same
> kernel?  This one was very interesting, since it seemed to fail with
> -EISDIR while opening .git/objects/pack.  Which is a directory and which
> should fail with -EISDIR if and only if we pass O_CREAT to open().  And
> passing O_CREAT on that one is probably not an intended behaviour of git...
>
> Does anybody else see NFS breakage starting at that commit, BTW?  Other
> testcases would be useful...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>    

I also see it....didn't bisect it yet since I was in a rush and had a 
simple work around. I was doing a git pull between two repositories on a 
NFS 4 w/krb5 security. Got the error about .git/objects/pack (error: 
unable to open object pack directory: .git/objects/pack: Is a 
directory). If I then run 'ls .git/objects/pack', and then the 'git 
pull' again it works.

Doug

