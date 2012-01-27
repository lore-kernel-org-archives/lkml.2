Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab2A0Tew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 14:34:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60762 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab2A0Tev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 14:34:51 -0500
Message-ID: <4F22FC57.4090008@canonical.com>
Date: Fri, 27 Jan 2012 11:34:47 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120119 Thunderbird/10.0
MIME-Version: 1.0
To: Kees Cook <kees@ubuntu.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] AppArmor: add "file" details to securityfs
References: <1327624163-21576-1-git-send-email-kees@ubuntu.com> <1327624163-21576-4-git-send-email-kees@ubuntu.com>
In-Reply-To: <1327624163-21576-4-git-send-email-kees@ubuntu.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2012 04:29 PM, Kees Cook wrote:
> Create the "file" directory in the securityfs for tracking features
> related to files.
> 
> Signed-off-by: Kees Cook <kees@ubuntu.com>
Acked-by: John Johansen <john.johansen@canonical.com>

> ---
>  security/apparmor/apparmorfs.c         |   10 ++++++++++
>  security/apparmor/include/apparmorfs.h |    6 ++++++
>  2 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
> index 36efe64..68ce771 100644
> --- a/security/apparmor/apparmorfs.c
> +++ b/security/apparmor/apparmorfs.c
> @@ -154,6 +154,9 @@ static int aa_fs_seq_show(struct seq_file *seq, void *v)
>  	case AA_FS_TYPE_BOOLEAN:
>  		seq_printf(seq, "%s\n", fs_file->v.boolean ? "yes" : "no");
>  		break;
> +	case AA_FS_TYPE_STRING:
> +		seq_printf(seq, "%s\n", fs_file->v.string);
> +		break;
>  	case AA_FS_TYPE_U64:
>  		seq_printf(seq, "%#08lx\n", fs_file->v.u64);
>  		break;
> @@ -180,6 +183,12 @@ const struct file_operations aa_fs_seq_file_ops = {
>  
>  /** Base file system setup **/
>  
> +static struct aa_fs_entry aa_fs_entry_file[] = {
> +	AA_FS_FILE_STRING("mask", "create read write exec append mmap_exec " \
> +				  "link lock"),
> +	{ }
> +};
> +
>  static struct aa_fs_entry aa_fs_entry_domain[] = {
>  	AA_FS_FILE_BOOLEAN("change_hat",	1),
>  	AA_FS_FILE_BOOLEAN("change_hatv",	1),
> @@ -190,6 +199,7 @@ static struct aa_fs_entry aa_fs_entry_domain[] = {
>  
>  static struct aa_fs_entry aa_fs_entry_features[] = {
>  	AA_FS_DIR("domain",			aa_fs_entry_domain),
> +	AA_FS_DIR("file",			aa_fs_entry_file),
>  	AA_FS_FILE_BOOLEAN("namespaces",	1),
>  	AA_FS_FILE_U64("capability",		VFS_CAP_FLAGS_MASK),
>  	{ }
> diff --git a/security/apparmor/include/apparmorfs.h b/security/apparmor/include/apparmorfs.h
> index 16e6545..7ea4769 100644
> --- a/security/apparmor/include/apparmorfs.h
> +++ b/security/apparmor/include/apparmorfs.h
> @@ -17,6 +17,7 @@
>  
>  enum aa_fs_type {
>  	AA_FS_TYPE_BOOLEAN,
> +	AA_FS_TYPE_STRING,
>  	AA_FS_TYPE_U64,
>  	AA_FS_TYPE_FOPS,
>  	AA_FS_TYPE_DIR,
> @@ -31,6 +32,7 @@ struct aa_fs_entry {
>  	enum aa_fs_type v_type;
>  	union {
>  		bool boolean;
> +		char *string;
>  		unsigned long u64;
>  		struct aa_fs_entry *files;
>  	} v;
> @@ -43,6 +45,10 @@ extern const struct file_operations aa_fs_seq_file_ops;
>  	{ .name = (_name), .mode = 0444, \
>  	  .v_type = AA_FS_TYPE_BOOLEAN, .v.boolean = (_value), \
>  	  .file_ops = &aa_fs_seq_file_ops }
> +#define AA_FS_FILE_STRING(_name, _value) \
> +	{ .name = (_name), .mode = 0444, \
> +	  .v_type = AA_FS_TYPE_STRING, .v.string = (_value), \
> +	  .file_ops = &aa_fs_seq_file_ops }
>  #define AA_FS_FILE_U64(_name, _value) \
>  	{ .name = (_name), .mode = 0444, \
>  	  .v_type = AA_FS_TYPE_U64, .v.u64 = (_value), \

