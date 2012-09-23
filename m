Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2IWWhw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 18:37:52 -0400
Received: from ppsw-43.csi.cam.ac.uk ([131.111.8.143]:45857 "EHLO
	ppsw-43.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab2IWWht convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 18:37:49 -0400
X-Greylist: delayed 1168 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Sep 2012 18:37:49 EDT
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: cifs: fix return value in cifsConvertToUTF16
Mime-Version: 1.0 (Mac OS X Mail 6.1 \(1498\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <20120922202809.250DB3402DF@ra.kernel.org>
Date: Sun, 23 Sep 2012 23:18:19 +0100
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Unix Support <unix-support@ucs.cam.ac.uk>
Content-Transfer-Encoding: 8BIT
Message-Id: <96965BD0-8BA7-41C0-A459-7F4DC871F607@cam.ac.uk>
References: <20120922202809.250DB3402DF@ra.kernel.org>
To: Steve French <sfrench@samba.org>
X-Mailer: Apple Mail (2.1498)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

Hey, I sent you that exact same patch on the 12th June!  Would have saved you and others some valuable time if you hadn't ignored it then!  (-;

Told you it was an obvious logic bug!  (-;

Best regards,

	Anton

On 22 Sep 2012, at 21:28, Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/linus/;a=commit;h=c73f693989d7a7d99ec66a7065295a0c93d0b127
> Commit:     c73f693989d7a7d99ec66a7065295a0c93d0b127
> Parent:     4651afbbae968772efd6dc4ba461cba9b49bb9d8
> Author:     Jeff Layton <jlayton@redhat.com>
> AuthorDate: Tue Sep 18 14:21:01 2012 -0400
> Committer:  Steve French <smfrench@gmail.com>
> CommitDate: Tue Sep 18 15:35:25 2012 -0500
> 
>    cifs: fix return value in cifsConvertToUTF16
> 
>    This function returns the wrong value, which causes the callers to get
>    the length of the resulting pathname wrong when it contains non-ASCII
>    characters.
> 
>    This seems to fix https://bugzilla.samba.org/show_bug.cgi?id=6767
> 
>    Cc: <stable@vger.kernel.org>
>    Reported-by: Baldvin Kovacs <baldvin.kovacs@gmail.com>
>    Reported-and-Tested-by: Nicolas Lefebvre <nico.lefebvre@gmail.com>
>    Signed-off-by: Jeff Layton <jlayton@redhat.com>
>    Signed-off-by: Steve French <smfrench@gmail.com>
> ---
> fs/cifs/cifs_unicode.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> index 7dab9c0..53cf2aa 100644
> --- a/fs/cifs/cifs_unicode.c
> +++ b/fs/cifs/cifs_unicode.c
> @@ -328,7 +328,7 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
> 	}
> 
> ctoUTF16_out:
> -	return i;
> +	return j;
> }
> 
> #ifdef CONFIG_CIFS_SMB2

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

